From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH V1 3/3] scsi: ufs: Add sysfs support for ufs provision
Date: Tue, 5 Jun 2018 10:42:00 +0200
Message-ID: <20180605084200.GB8665@kroah.com>
References: <1527849774-7623-1-git-send-email-sayalil@codeaurora.org>
 <1527849774-7623-4-git-send-email-sayalil@codeaurora.org>
 <MWHPR04MB113794E2654BEDA8E927F0FC9A660@MWHPR04MB1137.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <MWHPR04MB113794E2654BEDA8E927F0FC9A660@MWHPR04MB1137.namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>
Cc: Sayali Lokhande <sayalil@codeaurora.org>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "cang@codeaurora.org" <cang@codeaurora.org>, "vivek.gautam@codeaurora.org" <vivek.gautam@codeaurora.org>, "rnayak@codeaurora.org" <rnayak@codeaurora.org>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>, "evgreen@chromium.org" <evgreen@chromium.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Adrian Hunter <adrian.hunter@intel.com>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 05, 2018 at 08:16:50AM +0000, Stanislav Nijnikov wrote:
> Hi Sayali,
> 
> I think that passing an array of values in a string is not proper way
> to work with a sysfs entry. There are binary attributes to do such
> things.

No, don't do that, sysfs is for "one value per file", and binary
attributes are for "hardware value pass-through" type stuff.  Unless
this is "raw" data straight from the hardware, binary does not work, and
neither does a normal sysfs file either.

So this needs to be reworked please.

thanks,

greg k-h
