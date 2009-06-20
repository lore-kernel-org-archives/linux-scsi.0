From: Ravish Tayal <ravish.tayal@gmail.com>
Subject: Re: generic_make_request fucntion for scsi_disk
Date: Sat, 20 Jun 2009 21:03:00 +0530
Message-ID: <e42309110906200833q52b392d3n592712c0f81b6c9c@mail.gmail.com>
References: <e42309110906200746u441b82acvec4e3e513253af0@mail.gmail.com>
	 <Pine.LNX.4.44L0.0906201052090.13441-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0906201052090.13441-100000@netrider.rowland.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Sorry My mistake.
I will take care of it now onwards
regards
Ravish


On Sat, Jun 20, 2009 at 8:26 PM, Alan Stern<stern@rowland.harvard.edu> =
wrote:
> You should use Reply-To-All so that other people reading the mailing
> list will be able to follow and contribute to the thread.
>
> On Sat, 20 Jun 2009, Ravish Tayal wrote:
>
>> Thanks Alan,
>>
>> I am actually trying to profile the time taken by each layer to comp=
lete the
>> disk write opertaion as sys_write to queue_command invokation veries=
 alot.
>
> Of course it varies. =A0The kernel buffers disk writes, shuffles them
> around, and then carries them out when it wants to. =A0As James has
> pointed out, your write(2) system calls don't directly cause any I/O =
to
> take place.
>
> Alan Stern
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
