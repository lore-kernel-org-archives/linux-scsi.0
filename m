From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: 2.5 scsi mid level - lower level interface description
Date: Wed, 24 Apr 2002 11:43:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020424114333.A12025@beaverton.ibm.com>
References: <3CC61421.ACA708DE@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3CC61421.ACA708DE@torque.net>; from dougg@torque.net on Tue, Apr 23, 2002 at 10:10:41PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

Douglas Gilbert [dougg@torque.net] wrote:
> The attachment attempts to describe the interface between
> the scsi mid level and lower level drivers in the lk 2.5
> series.
> 
> It is a text file which I plan to place in the drivers/scsi
> directory. At the same time the rather dated callback
> function documentation in hosts.h could be removed and replaced 
> with a reference to this text file.

Good Document...

What about storing just part of the document in drivers/scsi?

Since the function descriptions are marked up for kernel-doc and kernel-doc runs on
your text document with a little bit of error output what about creating a
template portion of this document and then a api portion? 

The api portion could remain in the scsi directory and be included with a
!Edrivers/scsi/scsi_mid_low_api.txt. The struct data you reference could
also be obtained from the hosts.h, scsi.h, etc.

Using this method might help keep documentation in sync with the structs /
interfaces.

-Mike

-- 
Michael Anderson
andmike@us.ibm.com

