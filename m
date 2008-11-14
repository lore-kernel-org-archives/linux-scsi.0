From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [RFC][PATCH] Handle multipath paths in a path group properly
	during pg_init (was "RE: DM does not activate the
	paths if there are more than one path in path group during failover")
Date: Fri, 14 Nov 2008 19:34:58 +0000
Message-ID: <20081114193458.GV30569@agk.fab.redhat.com>
References: <1225944321.14830.1109.camel@chandra-ubuntu>
	<E463DF2B2E584B4A82673F53D62C2EF45BE759CF@cosmail01.lsi.com>
	<20081111005920.GN16649@agk.fab.redhat.com>
	<E463DF2B2E584B4A82673F53D62C2EF45BE75B7F@cosmail01.lsi.com>
	<1226620138.8998.64.camel@chandra-ubuntu>
	<20081114001205.GQ30569@agk.fab.redhat.com>
	<1226689728.8998.76.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1226689728.8998.76.camel@chandra-ubuntu>
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
Cc: Mike Anderson <andmike@us.ibm.com>, Levy_Jerome <Levy_Jerome@emc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, asson_ronald <asson_ronald@emc.com>, device-mapper development <dm-devel@redhat.com>, Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 14, 2008 at 11:08:48AM -0800, Chandra Seetharaman wrote:
> No, I "replaced" the "per-group" pg_init with "per-path" init.
 
Indeed, but I'm pointing out that the per-group initialisation was
originally added for EMC and arguing that per-group initialisation
and per-path initialisation are independent conceptually and the
code may need to support both: adding one to deal with the problem
reported here need not necessitate removing the other.

Alasdair
-- 
agk@redhat.com
