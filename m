From: Christoph Hellwig <hch@infradead.org>
Subject: Re: about scsi_hostlist
Date: Sun, 17 Nov 2002 22:35:58 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021117223558.A22956@infradead.org>
References: <200211172212.gAHMCp99017977@leviathan.ele.uri.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200211172212.gAHMCp99017977@leviathan.ele.uri.edu>; from mingz@ele.uri.edu on Sun, Nov 17, 2002 at 05:11:28PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Ming Zhang <mingz@ele.uri.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Sun, Nov 17, 2002 at 05:11:28PM -0500, Ming Zhang wrote:
> Hi, I meet a problem when port my code to 2.5.47.
> My goal is to get all scsi disk Scsi_Device pointers.
> 
> For 2.4.18, I can use scsi_hostlist to travel through the list and get all pointer by comparing type if TYPE_DISK. But in 2.5.47, there is no such pointer. And that scsi_host_list can not be used.

You are not supposed to walk any lists that are private to the
midlayer (like scsi_hostlist).   What do you try to archive?
