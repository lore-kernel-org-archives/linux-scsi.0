From: Doug Ledford <dledford@redhat.com>
Subject: Re: Autosense requirement
Date: Mon, 29 Jul 2002 18:36:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020729183611.R20905@redhat.com>
References: <3679966B84813344B908D418BA3F6A4AA83FAD@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3679966B84813344B908D418BA3F6A4AA83FAD@AVEXCH01.qlogic.org>; from ravi.anand@qlogic.com on Mon, Jul 29, 2002 at 03:28:14PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: Mike Anderson <andmike@us.ibm.com>, linux-scsi@vger.kernel.org

On Mon, Jul 29, 2002 at 03:28:14PM -0700, Ravi Anand wrote:
> Does this also mean low level driver will be responsible for taking action on the basis of the sense data coming back from the device ?

No, it just has to get the data and then complete the command to the mid 
layer.  The mid layer will handle doing the "Right Thing" based upon the 
sense data.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
