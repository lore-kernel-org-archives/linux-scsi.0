From: Christoph Hellwig <hch@infradead.org>
Subject: Re: drop scsi_register_blocked_host() in 2.5?
Date: Mon, 24 Feb 2003 20:17:40 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030224201740.A13910@infradead.org>
References: <70652A801D9E0C469C28A0F8BCF49CF9012EBD27@itmi1mx2.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <70652A801D9E0C469C28A0F8BCF49CF9012EBD27@itmi1mx2.corp.emc.com>; from Ballabio_Dario@emc.com on Mon, Feb 24, 2003 at 03:32:09AM -0500
List-Id: linux-scsi@vger.kernel.org
To: Ballabio_Dario@emc.com
Cc: hch@infradead.org, dougg@torque.net, linux-scsi@vger.kernel.org

On Mon, Feb 24, 2003 at 03:32:09AM -0500, Ballabio_Dario@emc.com wrote:
> This means giving up forever to support multiple isa scsi hba's.
> The aim of these routines (left unimplemented by Eric during the 2.3
> development cycle)
> was to allow multiple isa hba working at the same time, but being active
> one at a time. If you try to do heavy i/o on a system with multiple u14-34f
> or isa eata boards (I have not tested aha1542 but it is probably the same)
> it crashes immediately due to data corruption at the isa bus level.
> Using a 2.2 kernel the same system works perfectly.

The stubs won't help you to reach that goal.  Feel free to bring them back
once you have an actual implementation.

