From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: How to add/drop SCSI drives from within the driver?
Date: Tue, 25 Jan 2005 08:52:00 -0800
Message-ID: <20050125165200.GA30003@us.ibm.com>
References: <0E3FA95632D6D047BA649F95DAB60E57033BCCC6@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261907AbVAYQwx@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BCCC6@exa-atlanta>
Sender: linux-kernel-owner@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: 'James Bottomley' <James.Bottomley@SteelEye.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Atul -

On Tue, Jan 25, 2005 at 11:27:36AM -0500, Mukker, Atul wrote:
> After writing the "- - -" to the scan attribute, the management applications
> assume the udev has created the relevant entries in the /dev directly and
> try to use the devices _immediately_ and fail to see the devices
> 
> Is there a hotplug event which would tell the management applications that
> the device nodes have actually been created now and ready to be used?

Read the udev man page section, the part right before "FILES". Try
putting a script under /etc/dev.d/default/*.dev. Then you can get more
specific with an /etc/dev.d/scsi/*.dev script or something else.

I just tried something simple but did not get it working.

Try linux-hotplug-devel@lists.sourceforge.net list for help.

-- Patrick Mansfield
