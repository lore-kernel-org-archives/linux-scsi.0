From: Scott Merritt <Scsi@PragmaSoft.com>
Subject: Re: [PATCH] SCSI hotplug support
Date: Tue, 15 Oct 2002 15:50:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021015155038.6cd64b6a.Scsi@PragmaSoft.com>
References: <andersen@codepoet.org>
	<20021014203749.GA24904@codepoet.org>
	<200210142107.g9EL7IX04354@localhost.localdomain>
	<20021014215416.GB25941@codepoet.org>
	<20021014222515.GD1274@redhat.com>
	<20021015052521.GA1967@codepoet.org>
	<20021015182247.GA4391@redhat.com>
	<20021015184535.GA16401@codepoet.org>
	<20021015191330.GC4391@redhat.com>
	<20021015193216.GE15778@codepoet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021015193216.GE15778@codepoet.org>
List-Id: linux-scsi@vger.kernel.org
To: andersen@codepoet.org
Cc: linux-scsi@vger.kernel.org

On Tue, 15 Oct 2002 13:32:16 -0600
Erik Andersen <andersen@codepoet.org> wrote:

> The main reason why I'd prefer to put this stuff into the sbp2
> driver is to avoid 1394 layering violations.

I don't know much about this at all, but could the sbp2 driver "trigger" a second scsi-hotplug event ?  Hope I'm not make a truly silly suggestion ...

Regards, Scott.
