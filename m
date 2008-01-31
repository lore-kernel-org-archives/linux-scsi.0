From: "Nicholas A. Bellinger" <nab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [Fwd: Re: Integration of SCST in the mainstream Linux
	kernel]
Date: Thu, 31 Jan 2008 05:34:11 -0800
Message-ID: <1201786451.11265.1.camel@haakon2.linux-iscsi.org>
Reply-To: nab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-eIa5ttMtT9LRDuRFM0mm"
Return-path: <stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
List-Unsubscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.berlios.de/pipermail/stgt-devel>
List-Post: <mailto:stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
List-Help: <mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=help>
List-Subscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=subscribe>
Sender: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
Errors-To: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
To: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, STGT-Devel <stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


--=-eIa5ttMtT9LRDuRFM0mm
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

My original email probably got bounced..

--nab

--=-eIa5ttMtT9LRDuRFM0mm
Content-Disposition: inline
Content-Description: Forwarded message - Re: Integration of SCST in the
	mainstream Linux kernel
Content-Type: message/rfc822

Subject: Re: Integration of SCST in the mainstream Linux kernel
From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
To: FUJITA Tomonori <tomof-HInyCGIudOg@public.gmane.org>
Cc: bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org,  James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,  akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, vst-d+Crzxg7Rs0@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,  scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
In-Reply-To: <20080130195635T.tomof-HInyCGIudOg@public.gmane.org>
References: <adazluoe2t3.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
	 <20080130083239E.fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	 <20080130195635T.tomof-HInyCGIudOg@public.gmane.org>
Content-Type: text/plain
Message-Id: <1201785938.7280.105.camel-Y1+j5t8j3WgjMeEPmliV8E/sVC8ogwMJ@public.gmane.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Date: Thu, 31 Jan 2008 05:25:41 -0800
Content-Transfer-Encoding: 7bit

Greetings all,

On Wed, 2008-01-30 at 19:56 +0900, FUJITA Tomonori wrote:
> On Wed, 30 Jan 2008 09:38:04 +0100
> "Bart Van Assche" <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > On Jan 30, 2008 12:32 AM, FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
> > >
> > > iSER has parameters to limit the maximum size of RDMA (it needs to
> > > repeat RDMA with a poor configuration)?
> > 
> > Please specify which parameters you are referring to. As you know I
> 
> Sorry, I can't say. I don't know much about iSER. But seems that Pete
> and Robin can get the better I/O performance - line speed ratio with
> STGT.
> 
> The version of OpenIB might matters too. For example, Pete said that
> STGT reads loses about 100 MB/s for some transfer sizes for some
> transfer sizes due to the OpenIB version difference or other unclear
> reasons.
> 
> http://article.gmane.org/gmane.linux.iscsi.tgt.devel/135
> 
> It's fair to say that it takes long time and need lots of knowledge to
> get the maximum performance of SAN, I think.
> 
> I think that it would be easier to convince James with the detailed
> analysis (e.g. where does it take so long, like Pete did), not just
> 'dd' performance results.
> 
> Pushing iSCSI target code into mainline failed four times: IET, SCST,
> STGT (doing I/Os in kernel in the past), and PyX's one (*1). iSCSI
> target code is huge. You said SCST comprises 14,000 lines, but it's
> not iSCSI target code. The SCSI engine code comprises 14,000
> lines. You need another 10,000 lines for the iSCSI driver. Note that
> SCST's iSCSI driver provides only basic iSCSI features. PyX's iSCSI
> target code implemenents more iSCSI features (like MC/S, ERL2, etc)
> and comprises about 60,000 lines and it still lacks some features like
> iSER, bidi, etc.
> 

The PyX storage engine supports a scatterlist linked list algorithm that
maps any sector count + sector size combination down to contiguous
struct scatterlist arrays across (potentially) multiple Linux storage
subsystems from a single CDB received on a initiator port.  This design
was a consequence of a requirement for running said engine on Linux v2.2
and v2.4 across non cache coherent systems (MIPS R5900-EE) using a
single contiguous memory block mapped into struct buffer_head for PATA
access, and struct scsi_cmnd access on USB storage.  Note that this was
before struct bio and struct scsi_request existed..

The PyX storage engine as it exists at Linux-iSCSI.org today can be
thought of as a hybrid OSD processing engine, as it maps storage object
memory across a number of tasks from a received command CDB.  The
ability to pass in pre allocated memory from an RDMA capable adapter, as
well as allocated internally (ie: traditional iSCSI without open_iscsi's
struct skbuff rx zero-copy) is inherient in the design of the storage
engine.  The lacking Bidi support can be attributed to lack of greater
support (and hence user interest) in Bidi, but I am really glad to see
this getting into the SCSI ML and STGT, and is certainly of interest in
the long term.  Another feature that is missing in the current engine is
> 16 Byte CDBs, which I would imagine alot of vendor folks would like to
see in Linux as well.  This is pretty easy to add in iSCSI with an AHS
and in the engine and storage subsystems.

> I think that it's reasonable to say that we need more than 'dd'
> results before pushing about possible more than 60,000 lines to
> mainline.
> 
> (*1) http://linux-iscsi.org/
> -

The 60k lines of code also includes functionality (the SE mirroring
comes to mind) that I do not plan to push towards mainline, along with
other legacy bits so we can build on earlier v2.6 embedded platforms.
The existing Target mode LIO-SE that provides linked list scatterlist
mapping algorithm that is similar to what Jens and Rusty have been
working on, and is under 14k lines including the switch(cdb[0]) +
function pointer assignment to per CDB specific structure that is called
potentially out-of-order in the RX side context of the CmdSN state
machine in RFC-3720.  The current SE is also lacking the very SCSI
specific task management state machines that not a whole lot of iSCSI
implementions implement properly, and seem to be minimal interest to
users, and of moderate interest to vendors.  Getting this implemented
generically in SCSI, as opposed to an transport specific mechanisim
would benefit the Linux SCSI target engine.

The pSCSI (struct scsi_cmnd), iBlock (struct bio) and FILE (struct file)
plugins together are a grand total of 3.5k lines using the v2.9 LIO-SE
interface.  Assuming we have a single preferred data and control patch
for underlying physical and virtual block devices, this could also get
smaller.  A quick check of the code puts the traditional kernel level
iSCSI statemachine at roughly 16k, which is pretty good for the complete
state machine.  Also, having iSER and traditional iSCSI share MC/S and
ERL=2 common code will be of interest, as well as iSCSI login state
machines, which are identical minus the extra iSER specific keys and
requirement to transition from byte stream mode to RDMA accelerated
mode.

Since this particular code is located in a non-data path critical
section, the kernel vs. user discussion is a wash.  If we are talking
about data path, yes, the relevance of DD tests in kernel designs are
suspect :p.  For those IB testers who are interested, perhaps having a
look with disktest from the Linux Test Project would give a better
comparision between the two implementations on a RDMA capable fabric
like IB for best case performance.  I think everyone is interested in
seeing just how much data path overhead exists between userspace and
kernel space in typical and heavy workloads, if if this overhead can be
minimized to make userspace a better option for some of this very
complex code.

--nab

> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--=-eIa5ttMtT9LRDuRFM0mm
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Stgt-devel mailing list
Stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
https://lists.berlios.de/mailman/listinfo/stgt-devel

--=-eIa5ttMtT9LRDuRFM0mm--
