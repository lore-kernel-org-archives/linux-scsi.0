From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [Bug 14159] AIC79xx is not working properly with an attached
 scsi tape since 2.6.29
Date: Tue, 15 Sep 2009 13:53:30 +0000
Message-ID: <1253022810.29947.0.camel@mulgrave.site>
References: <bug-14159-11613@http.bugzilla.kernel.org/>
	 <200909150705.n8F75mDf004633@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <200909150705.n8F75mDf004633@demeter.kernel.org>
Sender: linux-acpi-owner@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2009-09-15 at 07:05 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=14159

cc'ing linux-acpi

James

> --- Comment #7 from g.giorgetti@teamsystem.com  2009-09-15 07:05:46 ---
> Hi Bjorn and James,
> 
> pci=noacpi is not working, so even before reading Bjorn's reply, we tried
> "noapic" and the suddenly the tape device was working again. No more timeouts
> on initialization and so on.
> 
> I haven't tried pci=noioapicquirk yet, since the server is up for production
> and other people is working. 
> So I'm gonna do that later in the day.
> 
> Thank you very much for now.
> 
> Regards,
>  Gabriele
> 

