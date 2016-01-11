From: "Seymour, Shane M" <shane.seymour@hpe.com>
Subject: RE: [PATCH] [SCSI] osst: remove double conversion of timeout
Date: Mon, 11 Jan 2016 00:54:48 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB4450A1AF@G9W0766.americas.hpqcorp.net>
References: <1452197433-26086-1-git-send-email-hofrat@osadl.org>
 <DDB9C85B850785449757F9914A034FCB445092F8@G9W0766.americas.hpqcorp.net>
 <20160108073155.GA16584@osadl.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160108073155.GA16584@osadl.at>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Nicholas Mc Guire <hofrat@osadl.org>, Willem Riede <osst@riede.org>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "osst-users@lists.sourceforge.net" <osst-users@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> did I overlook something here ?

You probably didn't overlook anything my comments were based on how msleep
was coded.

---
Reviewed-by: Shane Seymour <shane.seymour@hpe.com>
