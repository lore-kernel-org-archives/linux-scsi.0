From: Chris Weiss <cweiss@gmail.com>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Tue, 24 Aug 2010 09:51:04 -0500
Message-ID: <AANLkTi=m15OJg+QsM76r1O74OWjdxht3tqza1DYEeLVw@mail.gmail.com>
References: <594039.74663.qm@web111905.mail.gq1.yahoo.com> <1282144271.3035.31.camel@mulgrave.site>
 <AANLkTinRDMXqyDAVkcbioD=L7XO-47KHL2qjR+8KA5m3@mail.gmail.com>
 <1282148296.3035.49.camel@mulgrave.site> <4C6C1D70.7020502@vlnb.net>
 <41A1E2691BBB412BADCDE5F515CD8EDA@usish.com.cn> <8A96806D-6CD7-44AD-8A9D-143C098C95A4@uni-paderborn.de>
 <1282256949.30453.278.camel@haakon2.linux-iscsi.org> <4C701E08.2020005@vlnb.net>
 <1282423398.3015.39.camel@mulgrave.site> <4C73DA15.2010207@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C73DA15.2010207@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, Chetan Loke <chetanloke@gmail.com>, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 24, 2010 at 9:41 AM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
> James Bottomley, on 08/22/2010 12:43 AM wrote:
>> Interface re-use (or at least ABI compatibility) is the whole point,
>> it's what makes the solution a drop in replacement.
>
> I see now. You want ABI compatibility to keep the "contract" that no
> kernel changes can break applications binary compatibility for unlimited
> time.

ok now I'm confused, or maybe I'm not understanding ABI correctly, or
maybe you guys are using it in a way that is inconsistent with popular
convention.   As a VMware user, I have experienced fully that the
kernel ABI changes in various places with every release.  VMwares
drivers have to be constantly updated to match changes in kernel
function parameters and even what functions are available.

I've also experienced it with scsi cards, dsl modems, and other 3rd
party drivers.  It's the one big downside to developing for the Linux
kernel, the ABI is /always/ changing.
