From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: dm-mpath: Fix setup_scsi_dh()
Date: Mon, 17 Sep 2018 08:34:15 -0700
Message-ID: <84a32554-f5c4-3b22-bd3a-9b3af052611d@acm.org>
References: <20180917033354.30745-1-bvanassche@acm.org>
	<20180917142046.GA52842@redhat.com>
	<31642b58-a1de-a162-e9db-46e5a589e2b9@acm.org>
	<20180917151113.GA30042@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180917151113.GA30042@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 9/17/18 8:11 AM, Mike Snitzer wrote:
> Moving kfree() into setup_scsi_dh() would require use of a common goto
> for cleanup (something parse_path() already has with 'goto bad;').
> 
> But having kfree() in parse_path() is cleaner/symmetric since call to
> scsi_dh_attached_handler_name() -- and associated memory allocation --
> occurs in parse_path().
> 
> If you're OK with this, I'll get a proper patch staged based on your
> header and obviously add a Reported-by attributed to you.

That sounds fine to me.

Thanks!

Bart.
