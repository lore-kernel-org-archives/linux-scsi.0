From: vaughan <vaughan.cao@oracle.com>
Subject: Re: PROBLEM: special sense code asc,ascq=04h,0Ch abort scsi scan
 in the middle
Date: Wed, 16 Oct 2013 15:26:00 +0800
Message-ID: <525E3F88.9070004@oracle.com>
References: <525AD704.6040705@oracle.com> <525BD1EA.6000701@suse.de> <525BE8C1.5090606@linux.vnet.ibm.com> <525BEF2B.2030907@suse.de> <525BF256.6060707@suse.de> <525C0CAE.3030803@linux.vnet.ibm.com> <525E37CA.2000605@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <525E37CA.2000605@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Steffen Maier <maier@linux.vnet.ibm.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/16/2013 02:52 PM, Hannes Reinecke wrote:
> But seeing that this approach raises quite some issues I've attached a
> different patch. Vaughan, could you test with that, too? Should be
> functionally equivalent to the previous one. Cheers, Hannes 
Of course. This one is more clear to express our intention than setting
PQ 3 to break out.

Vaughan
