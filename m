From: "Mukker, Atul" <atulm@lsil.com>
Subject: unique entry points for all driver hosts
Date: Mon, 12 May 2003 18:41:50 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570185F192@EXA-ATLANTA.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Mukker, Atul" <Atulm@lsil.com>
List-Id: linux-scsi@vger.kernel.org

Why doesn't mid-layer allow LLDs to specify separate entry points to various
hosts attached to the same driver. Like some other entries in the Scsi Host
Template, entry points should also  allowed to be overridden.


Thanks

-Atul Mukker
Storage Systems
LSI Logic Corporation
