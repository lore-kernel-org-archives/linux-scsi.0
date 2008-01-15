From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [RFC] A SCSI fault injection framework using SystemTap.
Date: Tue, 15 Jan 2008 11:17:04 +0000
Message-ID: <20080115111704.GJ8075@agk.fab.redhat.com>
References: <478C22A9.5000009@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <478C22A9.5000009@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 15, 2008 at 12:04:09PM +0900, K.Tanaka wrote:
>   -dm-mirror's redundancy doesn't work. A read error from the disk consisting
>    the array will be directory passed to the userspace, without reading from
>    the other mirror.
>    (It turns out that this issue is a known issue, but the patch is not merged.
>     http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-raid1-handle-read-failures.patch)
 
It's in the queue for 2.6.25.

Alasdair
-- 
agk@redhat.com
