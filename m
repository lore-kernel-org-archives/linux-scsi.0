From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: unique entry points for all driver hosts
Date: Tue, 13 May 2003 16:09:02 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030513160902.A26759@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E570185F196@EXA-ATLANTA.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570185F196@EXA-ATLANTA.se.lsil.com>; from atulm@lsil.com on Tue, May 13, 2003 at 09:43:52AM -0400
To: "Mukker, Atul" <atulm@lsil.com>
Cc: 'Mike Anderson' <andmike@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, May 13, 2003 at 09:43:52AM -0400, Mukker, Atul wrote:
> IMHO, declaring multiple SHTs as suggested by Christoph Hellwig may not be a
> good idea since it might appear like a hack, would lose the "template"
> ideology and is not object-oriented :-)

The linux kernel is a pragmatic mix of procedural and object oriented
concepts, if you want ideology please look elsewhere.  The template is
exactly a template for multiple hosts and if you driver supports different
enouigh boards you need multiple templates - it's pretty simple.  Not that
the template is used much at all..

> Host structure would be best place to have pointers to these hooks as well.

This is right but not how the linux scsi stack was written.  Removing them
now causes more pain then it would solve - just live with the extra indirection.
