From: Doug Ledford <dledford@redhat.com>
Subject: Re: [RFC][RFT] scsi_scan.c cleanup/rewrite
Date: Thu, 20 Jun 2002 14:17:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020620141717.A9181@redhat.com>
References: <OF8DE8DA9F.FE61DF6F-ONC1256BDE.002EB207@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <OF8DE8DA9F.FE61DF6F-ONC1256BDE.002EB207@de.ibm.com>; from MPESCHKE@de.ibm.com on Thu, Jun 20, 2002 at 10:49:55AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: patman@beaverton.ibm.com, linux-scsi@vger.kernel.org

On Thu, Jun 20, 2002 at 10:49:55AM +0200, Martin Peschke3 wrote:
> A suggestion:
> In my opinion, such a patch would avail from a cleanup of the SCSI stack
> data structures which should be done in the first place. I would like to
> see
> all those lists rethought and rewritten using list_heads and introducing
> some locks which are required to protect changes to these lists.

That's coming.  At least, I'm working on it right now so it's coming from 
me fairly soon, if not from someone else sooner.


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
