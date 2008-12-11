From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/3] libfc: A modular Fibre Channel library
Date: Fri, 12 Dec 2008 00:33:26 +0100
Message-ID: <20081211233326.GD25779@one.firstfloor.org>
References: <20081209231005.17830.92133.stgit@fritz> <20081209231016.17830.87180.stgit@fritz> <20081210000333.GC23556@one.firstfloor.org> <7C88852EF6F99F4EB538472FCFEBE22204287E4C@orsmsx509.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:39669 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbYLKXVn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Dec 2008 18:21:43 -0500
Content-Disposition: inline
In-Reply-To: <7C88852EF6F99F4EB538472FCFEBE22204287E4C@orsmsx509.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Zou, Yi" <yi.zou@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, "Love, Robert W" <robert.w.love@intel.com>, "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jgarzik@redhat.com" <jgarzik@redhat.com>, "davem@davemloft.net" <davem@davemloft.net>, "james.smart@emulex.com" <james.smart@emulex.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "jeykholt@cisco.com" <jeykholt@cisco.com>, "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>

> name. The dev_stats are allocated initially in a for_each_online_cpu)()
> loop, and after that, corresponding dev_stats is allocated/freed upon
> CPU_ONLINE/CPU_DEAD event callback fcoe_cpu_callback(), do you think
> this is also a problem in using NR_CPUS?

Yes, it's also a problem. Use num_possible_cpus()

-Andi
