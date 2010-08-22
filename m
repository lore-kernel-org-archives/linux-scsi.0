From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Sun, 22 Aug 2010 09:39:03 +0200
Message-ID: <AANLkTikcReFsYMhs1RkCHoRkL1+Q9WuptHj1xbx49YsA@mail.gmail.com>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com>
	<1282144271.3035.31.camel@mulgrave.site>
	<AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com>
	<1282148296.3035.49.camel@mulgrave.site>
	<4C6C1D70.7020502@vlnb.net>
	<41A1E2691BBB412BADCDE5F515CD8EDA@usish.com.cn>
	<8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de>
	<1282256949.30453.278.camel@haakon2.linux-iscsi.org>
	<4C701E08.2020005@vlnb.net>
	<1282423398.3015.39.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1282423398.3015.39.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, Dirk Meister <dmeister@uni-paderborn.de>, linux-scsi@vger.kernel.org, Chetan Loke <chetanloke@gmail.com>, Chetan Loke <generationgnu@yahoo.com>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Aug 21, 2010 at 10:43 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Sat, 2010-08-21 at 22:42 +0400, Vladislav Bolkhovitin wrote:
>> [ ... ]
>>
>> You forgot to mention one small thing. You are going to (re)use curr=
ent
>> STGT interface for user space backend, which in 5 years of being
>> mainline has not gained any noticeable interest, because it is
>> fundamentally slow.
>
> That's not exactly what the results of a speed comparison one of your
> people did said, now is it? =A0The results were actually not much
> difference on line speeds up to GigE.
>
> [ ... ]

I assume that you are referring to this message:
http://lkml.org/lkml/2008/1/29/387 ? You might have missed the reply
that was posted by Roland Dreier, a highly regarded kernel maintainer
and InfiniBand expert (http://lkml.org/lkml/2008/1/29/402):

"Maybe I'm all wet, but I think iSER vs. SRP should be roughly
comparable.  The exact formatting of various messages etc. is
different but the data path using RDMA is pretty much identical.  So
the big difference between STGT iSER and SCST SRP hints at some big
difference in the efficiency of the two implementations."

=46urthermore, I would like to clarify that Vlad hasn't asked me to
start working on the SCST project but that I selected the SCST project
myself after an extensive stability and performance comparison of four
existing open source storage target projects.

Bart.
