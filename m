From: James Smart <James.Smart@Emulex.Com>
Subject: Re: Disabling dev_loss_tmo?
Date: Wed, 14 Nov 2007 14:00:04 -0500
Message-ID: <473B45B4.3010708@emulex.com>
References: <47396A5B.5040001@linpro.no> <4739CE69.3040602@emulex.com>
	<473AAD88.307@linpro.no> <473B0644.3090403@emulex.com>
	<473B1692.8050606@linpro.no>
Reply-To: James.Smart@Emulex.Com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <473B1692.8050606@linpro.no>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, MLOEHR@de.ibm.com, Michael Reed <mdr@sgi.com>
List-Id: linux-scsi@vger.kernel.org

I've added the dm reflector to this email...

> Best would to have DM-multipath handle the disconnects gracefully, of
> course.  But since it doesn't appear to be happening anytime soon:  A
> workaround provided by the transport layer would be very welcome!  I
> don't use iSCSI or SAS with DM so I don't know if such a workaround is
> wanted there too, but with FC it is necessary.  Even if it is a bad
> approach it is much better than nothing, the way I see it.

Background of where this thread started is:
http://marc.info/?l=linux-scsi&m=119494675103771&w=2

Can someone from the DM community comment on where things are, or are
going, for handling disconnects w/ device teardown ??

-- james s
