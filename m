From: Christoph Hellwig <hch@lst.de>
Subject: [PING / RESEND] handling reservation conflicts in
	dm-mpath
Date: Tue,  2 Aug 2016 14:36:31 +0200
Message-ID: <1470141392-25479-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: hare@suse.com
List-Id: linux-scsi@vger.kernel.org

Hannes sent this patch a bit more than a year ago, but it got silently
dropped.  When using the pNFS SCSI layout we can easily hit a
failover "livelock" without it as the reservation conflicts on a
newly detected device that doesn't have layouts yet, or after a fency
will keep failing over from one path to another for no reason at all.

Any chance to get it into mainline now?
