From: Doug Ledford <dledford@redhat.com>
Subject: Re: Wide negotiation fails with 80->68 LVD adapter?
Date: Mon, 21 Oct 2002 12:34:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021021163424.GE28914@redhat.com>
References: <200210210514.g9L5ElYp006401@angle.badbox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210210514.g9L5ElYp006401@angle.badbox.com>
List-Id: linux-scsi@vger.kernel.org
To: Alexy Khrabrov <braver@pobox.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Oct 21, 2002 at 01:14:47AM -0400, Alexy Khrabrov wrote:
> 
> Greetings -- did anybody try to connect a SCSI SCA
> hard drive (with 80 pins) to an Adaptec 7899
> Ultra160 with 65 pins?  Mine seems unable to spin
> them at 160 Mbps.

[ snip long description ]

There is no difference between 68 pin drives and 80 pin drives as far as 
the controller and the drive are concerned.  It's all just a physical 
interconnect difference.  The problem you are describing is a 
non-functional SCA->wide adapter.  I have yet to ever find a simple 
wide<->SCA adapter that worked.  I've always had to have a real SCA 
backplane before things worked properly.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
