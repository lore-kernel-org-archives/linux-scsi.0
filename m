From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] scsi_debug 1.64 for lk2.5.47 mark II
Date: Sun, 17 Nov 2002 14:02:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021117190238.GB3280@redhat.com>
References: <3DD7A1AA.6040009@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DD7A1AA.6040009@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Mon, Nov 18, 2002 at 01:03:22AM +1100, Douglas Gilbert wrote:
> 
> cleans up BIOS geometry code (parts copied from the aic7xxx
> driver).


My opinion is that the aic7xxx bios geometry code is broken for really 
large devices, so you might want to think about that ;-)



-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
