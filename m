From: Willem Riede <wrlk@riede.org>
Subject: Re: [RFC] Change signal used to exit scsi error handlers
Date: Wed, 8 Jan 2003 17:53:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030108225302.GE1378@linnie.riede.org>
References: <20030101210555.GS1378@linnie.riede.org>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030101210555.GS1378@linnie.riede.org>; from wrlk@riede.org on Wed, Jan 01, 2003 at 16:05:55 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andmike@us.ibm.com

On 2003.01.01 16:05 Willem Riede wrote:
> I earlier reported, that the error handler for ide-scsi exits prematurely if modprobed
> from rc.sysinit. I put in some debug prints to apprehend the culprit responsible for
> sending the SIGHUP signal that causes the exit.
> 
[snip]
> 
> Since we want error handlers to survive, IMHO that means that the choice of signal
> for error handler exit is unfortunate. The source of scsi_error suggests SIGPWR
> might be a worthy alternative. I think that is true. From inspecting init source,
> it is not capable of sending SIGPWR. SIGPWR should never be sent by dying processes
> (its sole use should be from a power daemon _to_ init to shut the system down when
> the juice is running out).
> 
So nobody has any comments? But who decides whether to make this change?
>From the source it appears that the last person to touch scsi_error.c and hosts.c
is Mike Anderson. Does that make you the defacto maintainer, Mike?

Thanks, Willem Riede.
