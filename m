From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH] scsi_mid_low_api.txt for 2.5.46-bk3
Date: Thu, 7 Nov 2002 19:13:16 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33L2.0211071912160.30691-100000@dragon.pdx.osdl.net>
References: <3DCB0E51.5070407@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3DCB0E51.5070407@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Fri, 8 Nov 2002, Douglas Gilbert wrote:

| This patch against 2.5.46-bk3 is work in progress
| (since the interface is in flux). It dusts of some
| cobwebs, removes politically incorrect typedefs and
| describes slave_attach() and slave_detach(). It
| removes the revoke() description (per hch? changes).
|
| Is a section describing mid level functions provided
| for LLDDs (e.g. scsi_adjust_queue_depth() ) warranted?

Yes, please.

[LLDD = low-level device driver]

-- 
~Randy

