From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Enterprise patch needed - please help
Date: 30 May 2002 01:41:40 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1022719300.4124.312.camel@irongate.swansea.linux.org.uk>
References: <6BD67FFB937FD411A04F00D0B74FE87807C249F0@xrose06.rose.hp.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <6BD67FFB937FD411A04F00D0B74FE87807C249F0@xrose06.rose.hp.com>
List-Id: linux-scsi@vger.kernel.org
To: "HINCHMAN,PAUL    (HP-Roseville,ex1)" <paul_hinchman@hp.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Thu, 2002-05-30 at 00:23, HINCHMAN,PAUL (HP-Roseville,ex1) wrote:
> We need desparately a patch (or better yet) permanent integration of an
> enablement for Linux to see max_scsi_luns "out of the box", at least in
> "enterprise" kernels.  I'm not a coder, but I do test Linux connectivity to

Load the module with max_scsi_luns=number as an option

> negates support from whatever vendor (like SuSE and Red Hat).  So, an
> "out-of-the-box" solution is desparately needed.  Linux won't go far in the
> enterprise without fully enabled (and stress-tested) storage.  I'd like to
> see this change to the 2.4.18+ kernels and beyond, I think it would probably
> be simple. Any advice you folks could give me as to who to talk to and
> escalate this issue would be great.  I'll provide more info to anyone who
> thinks they can help.

What I am more curious about is why your storage system didn't get
enumerating using the SCSI-3 report luns code path

