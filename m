From: "Adam J. Richter" <adam@yggdrasil.com>
Subject: Re: Patch?: linux-2.5.45/drivers/scsi/hosts.[ch] - Eliminate scsi_host_tmpl_list
Date: Sat, 9 Nov 2002 21:40:58 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211100540.VAA27438@baldur.yggdrasil.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: hch@lst.de, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Oops!  I wrote:
>        If you disagree with this, please walk me through how the
>second "insmod foo" gets scsi ID 4 when the scsihosts string has
                ^^^
>reserved that ID for something else.  If you can actually produce
>the behavior in real life, that would be even better.

        I meant the second "insmod bar".

Adam J. Richter     __     ______________   575 Oroville Road
adam@yggdrasil.com     \ /                  Miplitas, California 95035
+1 408 309-6081         | g g d r a s i l   United States of America
