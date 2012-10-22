From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch/rfc/rft] sd: allocate request_queue on device's local
 numa node
Date: Mon, 22 Oct 2012 21:19:41 +0200
Message-ID: <50859C4D.7050309@kernel.dk>
References: <x49pq4axre1.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <x49pq4axre1.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2012-10-22 21:01, Jeff Moyer wrote:
> Hi,
> 
> All of the infrastructure is available to allocate a request_queue on a
> particular numa node, but it isn't being utilized at all.  Wire up the
> sd driver to allocate the request_queue on the HBA's local numa node.
> 
> This is a request for comments and testing (I've built and booted it,
> nothing more).  I believe that this should be a performance win, but I
> have no numbers to back it up as yet.  Suggestions for workloads to test
> are welcome.

Would seem pointless _not_ to do it, if we have the info. Some
scsi_debug non-delay fio microbenchmark should show it easily. Combine
with perf as needed to verify.


-- 
Jens Axboe
