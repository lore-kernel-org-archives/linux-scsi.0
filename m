From: Pete Clements <clem@clem.clem-digital.net>
Subject: Re: final SCSI updates (hopefully) for 2.6.0
Date: Mon, 24 Nov 2003 19:52:08 -0500 (EST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <200311250052.TAA16575@clem.clem-digital.net>
References: <1069716546.2870.69.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <1069716546.2870.69.camel@mulgrave> from James Bottomley at "Nov 24, 2003  5:29: 4 pm"
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: torvalds@osdl.org, akpm@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Quoting James Bottomley
  > This should be the final set of refcounting and bugfix updates.  It
  > contains the two refcounting fixes I identified earlier (now fully
  > tested) and a bugfix for the aic7xxx/aic79xx drivers which was caused by
  > one of the previous refcounting changes.
  > 
  > The patch is here
  > 
  > bk://linux-scsi.bkbits.net/scsi-bugfixes-2.6
  > 

FYI:
  Applied the patch set, cleared my hang on boot problem. Looks
  good now.

-- 
Pete Clements 
