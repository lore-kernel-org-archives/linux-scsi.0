From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] Change signal used to exit scsi error handlers
Date: 09 Jan 2003 00:50:22 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1042073422.25607.4.camel@irongate.swansea.linux.org.uk>
References: <20030101210555.GS1378@linnie.riede.org>
	 <20030108225302.GE1378@linnie.riede.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030108225302.GE1378@linnie.riede.org>
List-Id: linux-scsi@vger.kernel.org
To: wrlk@riede.org
Cc: linux-scsi@vger.kernel.org, andmike@us.ibm.com

On Wed, 2003-01-08 at 22:53, Willem Riede wrote:
> So nobody has any comments? But who decides whether to make this change?
> >From the source it appears that the last person to touch scsi_error.c and hosts.c
> is Mike Anderson. Does that make you the defacto maintainer, Mike?

People were occupied with important things - like finding out *why* it broke

