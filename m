From: Scott Merritt <Scsi@PragmaSoft.com>
Subject: Re: SCSI layer retries even when medium is not present
Date: Fri, 21 Mar 2003 10:42:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030321104242.42099a29.Scsi@PragmaSoft.com>
References: <Pine.LNX.4.44L0.0303211004050.806-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0303211004050.806-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org

On Fri, 21 Mar 2003 10:08:02 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> Can anybody explain why the SCSI layer issues READ-CAPACITY three times in
> a row (for an emulated direct-access drive) when each time the sense code
> indicates the medium is not present?
> 
> Wouldn't just once be enough?
> 
> Alan Stern

My understanding is that Andries Brouwer has fixed the "media not
present" handling in Linux Kernel 2.5 (presumably, it should not issue
*any* Read-Capacity requests).  These changes need to be backported
to the 2.4 tree.

Regards, Scott.
