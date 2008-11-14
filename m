From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [RFC][PATCH] Handle multipath paths in a path group properly
	during pg_init (was "RE: DM does not activate the
	paths if there are more than one path in path group during failover")
Date: Fri, 14 Nov 2008 00:12:05 +0000
Message-ID: <20081114001205.GQ30569@agk.fab.redhat.com>
References: <1225944321.14830.1109.camel@chandra-ubuntu>
	<E463DF2B2E584B4A82673F53D62C2EF45BE759CF@cosmail01.lsi.com>
	<20081111005920.GN16649@agk.fab.redhat.com>
	<E463DF2B2E584B4A82673F53D62C2EF45BE75B7F@cosmail01.lsi.com>
	<1226620138.8998.64.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1226620138.8998.64.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@us.ibm.com
Cc: Mike Anderson <andmike@us.ibm.com>, device-mapper development <dm-devel@redhat.com>, Mike Christie <mchristi@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 13, 2008 at 03:48:58PM -0800, Chandra Seetharaman wrote:
> The problem reported by Moger Babu was caused due to the architectural
> change made when we moved from dm hardware handler to SCSI hardware
> handler.
 
pg_init is single initialisation for the group.
It only needs to happen on one path.

It sounds to me that what you're adding here is a *per-path* initialisation,
something *separate* from (and additional to) the existing *per-group* pg_init.

Has this patch been tested on EMC?

Alasdair
-- 
agk@redhat.com
