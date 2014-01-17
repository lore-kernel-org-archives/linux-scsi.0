From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Why is (2 < 2) true? Is it a gcc bug?
Date: Fri, 17 Jan 2014 12:27:47 -0800
Message-ID: <878uue1hh8.fsf@tassilo.jf.intel.com>
References: <D9FFE20C522965449E182ACE73889AEB1A6A340F@IRSMSX105.ger.corp.intel.com>
	<CAADnVQLUP=7oxciVw97d76xtqs6_YjC6E2boPRO9y4m_sqjRCA@mail.gmail.com>
	<CAADnVQL=s8zc_ACSuPs8P3y-RB9Td8OZysM=0fj4sjzUPRzfGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAADnVQL=s8zc_ACSuPs8P3y-RB9Td8OZysM=0fj4sjzUPRzfGw@mail.gmail.com>
	(Alexei Starovoitov's message of "Fri, 17 Jan 2014 11:58:28 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: "Dorau, Lukasz" <lukasz.dorau@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, sebastian.riemer@profitbricks.com, richard.weinberger@gmail.com
List-Id: linux-scsi@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> disable Value Range Propagation pass:
> -fdisable-tree-vrp1 -fdisable-tree-vrp2
>
> and complete unroll pass:
> -fdisable-tree-cunrolli

Can you file a gcc bug with test case?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
