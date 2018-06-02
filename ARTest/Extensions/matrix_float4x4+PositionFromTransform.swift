//
//  matrix_float4x4+PositionFromTransform.swift
//  ARTest
//
//  Created by Victor Hao on 6/2/18.
//  Copyright © 2018 Victor Hao. All rights reserved.
//

import SceneKit

extension matrix_float4x4 {
    func positionFromTransform() -> SCNVector3 {
        return SCNVector3(columns.3.x, columns.3.y, columns.3.z)
    }
}
