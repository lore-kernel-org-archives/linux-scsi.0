From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] scsi_mid_low_api.txt for 2.5.46-bk3
Date: Fri, 8 Nov 2002 00:01:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021108050151.GA24946@redhat.com>
References: <3DCB0E51.5070407@torque.net> <Pine.LNX.4.33L2.0211071912160.30691-100000@dragon.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33L2.0211071912160.30691-100000@dragon.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

On Thu, Nov 07, 2002 at 07:13:16PM -0800, Randy.Dunlap wrote:
> On Fri, 8 Nov 2002, Douglas Gilbert wrote:
> 
> | This patch against 2.5.46-bk3 is work in progress
> | (since the interface is in flux). It dusts of some
> | cobwebs, removes politically incorrect typedefs and
> | describes slave_attach() and slave_detach(). It
> | removes the revoke() description (per hch? changes).
> |
> | Is a section describing mid level functions provided
> | for LLDDs (e.g. scsi_adjust_queue_depth() ) warranted?
> 
> Yes, please.
> 
> [LLDD = low-level device driver]

I am writing such a doc BTW, but I've been asleep for a few hours so I 
have chimed in ;-)

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
