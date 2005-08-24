From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC PATCH 1/4] convert block layer drivers to
	blkerr error values
Date: Wed, 24 Aug 2005 04:49:27 -0500
Message-ID: <430C42A7.3040008@cs.wisc.edu>
References: <1124874238.10888.18.camel@max>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1124874238.10888.18.camel@max>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: dm-devel@redhat.com, axboe@suse.de, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Mike Christie wrote:
> @@ -1049,7 +1049,6 @@ static void pkt_start_write(struct pktcd
>  	pkt->w_bio->bi_max_vecs = PACKET_MAX_SIZE;
>  	pkt->w_bio->bi_sector = pkt->sector;
>  	pkt->w_bio->bi_bdev = pd->bdev;
> -	pkt->w_bio->bi_end_io = pkt_end_io_packet_write;

oops I messed up my git checkins and stuff. This was a accident.
