From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [RFC PATCH 0/4] add new block layer error values
Date: Wed, 24 Aug 2005 04:03:50 -0500
Message-ID: <1124874230.10888.17.camel@max>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-scsi@vger.kernel.org, dm-devel@redhat.com, axboe@suse.de
List-Id: linux-scsi@vger.kernel.org

The current -Exyz errors are not descriptive enough to allow upper
layers like DM and MD to decide how to handle IO errors. In many cases
all we get is a -EIO. The following patches introduce block layer error
values for use with the bio_endio and end_that_request* functions
(end_request keeps uptodate).

This is just as a RFC I am still testing and working on them and am
hoping to get some comments. All patches were made against the
scsi-misc-2.6 tree.
