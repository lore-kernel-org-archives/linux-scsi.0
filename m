From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 00/18] prevent bounds-check bypass via speculative
 execution
Date: Sat, 6 Jan 2018 10:59:06 -0800
Message-ID: <e567c704-e141-63db-5d59-7294e0c78e26@linux.intel.com>
References: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
 <ca6f24c0-d6cf-e309-aa68-92f1378ee75a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <ca6f24c0-d6cf-e309-aa68-92f1378ee75a@gmail.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Florian Fainelli <f.fainelli@gmail.com>, Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, peterz@infradead.org, Alan Cox <alan.cox@intel.com>, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Will Deacon <will.deacon@arm.com>, Solomon Peachy <pizza@shaftnet.org>, "H. Peter Anvin" <hpa@zytor.com>, Christian Lamparter <chunkeey@googlemail.com>, Elena Reshetova <elena.reshetova@intel.com>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Zhang Rui <rui.zhang@intel.com>, linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Jan Kara <jack@suse.com>, Eduardo Valentin <edubezval@gmail.com>
List-Id: linux-scsi@vger.kernel.org

> It sounds like Coverity was used to produce these patches? If so, is
> there a plan to have smatch (hey Dan) or other open source static
> analysis tool be possibly enhanced to do a similar type of work?

I'd love for that to happen; the tricky part is being able to have even a
sort of sensible concept of "trusted" vs "untrusted" value...

if you look at a very small window of code, that does not work well;
you likely need to even look (as tool) across .c file boundaries
