From: "Vladimir G. Ivanovic" <vladimir@acm.org>
Subject: Re: Sym53c8xx_2
Date: Tue, 17 Aug 2004 11:06:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408171806.i7HI6uCv013784@bach.leonora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl081-052-249.sfo1.dsl.speakeasy.net ([64.81.52.249]:7924 "EHLO
	bach.leonora.org") by vger.kernel.org with ESMTP id S268362AbUHQSG7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 14:06:59 -0400
Received: from bach.leonora.org (localhost.localdomain [127.0.0.1])
	by bach.leonora.org (8.12.11/8.12.11) with ESMTP id i7HI6vnY013787
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 17 Aug 2004 11:06:57 -0700
Received: from bach.leonora.org (vladimir@localhost)
	by bach.leonora.org (8.12.11/8.12.11/Submit) with ESMTP id i7HI6uCv013784
	for <linux-scsi@vger.kernel.org>; Tue, 17 Aug 2004 11:06:57 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've had a similar problem for years with a Quantum ATLAS 10K3_18_WLS
attached to a LSI Logic/Symbios Logic 53c1010 Ultra3 SCSI Adapter.

I get errors like:

   sym0:6: ERROR (81:0) (47-67-19) (3e/18/80) @ (scripta 4b8:f31c0004).
   sym0:6: ERROR (81:0) (47-67-67) (3e/18/80) @ (mem f000ef74:ffffffff).
   sym0:6: ERROR (81:0) (47-67-7) (3e/18/80) @ (mem f000ef74:ffffffff).
   sym0:6: ERROR (81:0) (8-0-0) (3e/18/80) @ (mem 10c48404:fffec887).
   sym0:6: ERROR (81:0) (8-0-0) (3e/18/80) @ (scripta 38:f31c0004).
   sym0:6: ERROR (81:0) (c-0-0) (3e/18/80) @ (mem 1510158:04000000).
   sym0:6: ERROR (81:0) (c-0-0) (3e/18/80) @ (mem 6c6f707c:04000000).
   sym0:6: ERROR (81:0) (c-0-0) (3e/18/80) @ (mem 948174:04000000).

These are all Illegal Instruction Detected errors (81:0).

Switching controllers hasn't helped, nor has turning on and off
SCSI termination in the BIOS (on-board SCSI), nor has upgrading from a
2.4.x kernel to a 2.6.x kernel.

I have build a custom 2.6 kernel with all kernel debugging turned on,
and I am playing around with various debugging commands that can be sent
to the driver, but I'd really appreciate any advice on how to log and
debug these kind of problems.

Thanks.

--- Vladimir

------------------------------------------------------------------------
Vladimir G. Ivanovic                        http://leonora.org/~vladimir
Palo Alto, CA 94306                                      +1 650 678 8014
------------------------------------------------------------------------
