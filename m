From: rick.brown@oit.gatech.edu
Subject: more arrays for scsi_dh_rdac.c
Date: Tue, 11 Aug 2009 09:38:04 -0400 (EDT)
Message-ID: <1416234192.1340021249997884445.JavaMail.root@mail6.gatech.edu>
References: <981814294.1338791249997612929.JavaMail.root@mail6.gatech.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from deliverator11.gatech.edu ([130.207.165.83]:42805 "EHLO
	deliverator11.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbZHKODY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2009 10:03:24 -0400
Received: from deliverator1.ecc.gatech.edu (deliverator1.ecc.gatech.edu [130.207.185.171])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by deliverator11.gatech.edu (Postfix) with ESMTP id 853D6180379
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2009 09:39:12 -0400 (EDT)
Received: from deliverator1.ecc.gatech.edu (localhost [127.0.0.1])
	by localhost (Postfix) with SMTP id 9D1BB2DC0FE
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2009 09:38:10 -0400 (EDT)
Received: from mail6.gatech.edu (bigip.ecc.gatech.edu [130.207.185.140])
	by deliverator1.ecc.gatech.edu (Postfix) with ESMTP id B6E322DC284
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2009 09:38:08 -0400 (EDT)
Received: from mail6.gatech.edu (localhost [127.0.0.1])
	by mail6.gatech.edu (Postfix) with ESMTP id 9A35C225B4C
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2009 09:38:08 -0400 (EDT)
In-Reply-To: <981814294.1338791249997612929.JavaMail.root@mail6.gatech.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Please consider adding the following two devices to the devlist in scsi_dc_rdac.c

{"STK", "FLEXLINE 380"},
{"SUN", "CSM_100_R_FC"},

The Flexline 380 is also now known as the Sun StorageTek 6540, and the CSM_100_R_FC is also known as the Sun StorEdge 6130 - both are rebranded LSI arrays. 
 
-- 
Rick Brown
Office of Information Technology
Georgia Institute of Technology
258 4th Street N.W.  Atlanta, GA  30332-0715

