From: "Heinz, Michael" <mheinz@infiniconsys.com>
Subject: Revisiting task tags and Linux SCSI
Date: Wed, 8 May 2002 23:01:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <08628CA53C6CBA4ABAFB9E808A5214CB0C5E9D@mercury.infiniconsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Okay guys,

Maybe I'm an idiot - but I cannot find *anywhere* in sd.c, sg.c, scsi.c
or elsewhere that the scsi_cmnd.tag field is set to anything except
zero, nor can I find anywhere in the high level SCSI drivers that the
"scsi_device.tagged_*" fields are used. 

Am I wrong here? I can certainly generate task tags that are guaranteed
to be unique (I already have to do that anyway), and I can certainly
'or' them with ORDERED_QUEUE_TAG but I'm not sure how that's going to
impact the higher level SCSI drivers since they never pay attention to
the values of any of the "tagged_*" fields anyway.....

--
Michael Heinz
Infinicon Systems, Inc.
http://www.infiniconsys.com 
