From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: generic_make_request fucntion for scsi_disk
Date: Sat, 20 Jun 2009 10:56:09 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0906201052090.13441-100000@netrider.rowland.org>
References: <e42309110906200746u441b82acvec4e3e513253af0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <e42309110906200746u441b82acvec4e3e513253af0@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ravish Tayal <ravish.tayal@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

You should use Reply-To-All so that other people reading the mailing 
list will be able to follow and contribute to the thread.

On Sat, 20 Jun 2009, Ravish Tayal wrote:

> Thanks Alan,
> 
> I am actually trying to profile the time taken by each layer to complete the
> disk write opertaion as sys_write to queue_command invokation veries alot.

Of course it varies.  The kernel buffers disk writes, shuffles them 
around, and then carries them out when it wants to.  As James has 
pointed out, your write(2) system calls don't directly cause any I/O to 
take place.

Alan Stern


