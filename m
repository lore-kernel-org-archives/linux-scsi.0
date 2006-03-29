From: Ingo Flaschberger <if@xip.at>
Subject: typo in scsi_devinfo.h
Date: Wed, 29 Mar 2006 15:19:06 +0200 (CEST)
Message-ID: <Pine.GSO.4.64.0603291518230.4009@filebunker.xip.at>
References: <Pine.GSO.4.64.0602250050410.27649@filebunker.xip.at>
 <Pine.GSO.4.64.0602280120290.25994@filebunker.xip.at>
 <Pine.GSO.4.64.0602280130320.25994@filebunker.xip.at>
 <20060228004043.GH27759@parisc-linux.org> <Pine.GSO.4.64.0603221911370.14214@filebunker.xip.at>
 <yq1lkv2iap8.fsf@wilson.lab.mkp.net> <Pine.GSO.4.64.0603222054520.14214@filebunker.xip.at>
 <20060322200229.GT8980@parisc-linux.org> <Pine.GSO.4.64.0603222105560.14214@filebunker.xip.at>
 <Pine.GSO.4.64.0603282134370.8439@filebunker.xip.at> <yq18xqtain6.fsf@wilson.lab.mkp.net>
 <Pine.GSO.4.64.0603291305590.4009@filebunker.xip.at>
 <Pine.GSO.4.64.0603291428590.4009@filebunker.xip.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.xip.at ([193.239.188.99]:1188 "EHLO chile.gbit.at")
	by vger.kernel.org with ESMTP id S1751101AbWC2NTI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 08:19:08 -0500
In-Reply-To: <Pine.GSO.4.64.0603291428590.4009@filebunker.xip.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello,

in file include/scsi/scsi_devinfo.h:
#define BLIST_BORKEN            0x004   /* Flag for broken handshaking */
          ^^^^^^^^^^^^
          typo


bye,
 	ingo flaschberger

geschaeftsleitung
crossip communications gmbH
------------------------------------------------------------------_------------
sebastian kneipp gasse 1          _____ _____ ____   _____ _____ (_)____
a-1020 wien                      / ___// ___// __ \ / ___// ___// // __ \
fix: +43-1-726 15 22-217        / /__ / /   / /_/ /(__  )(__  )/ // /_/ /
fax: +43-1-726 15 22-111        \___//_/    \____//____//____//_// .___/
mob: +43-699-105 86 719                                 _______ / /
www.xip.at                      communications gmbh    /______//_/
-------------------------------------------------------------------------------
