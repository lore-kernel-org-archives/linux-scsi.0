From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: RE: SCSI Hardware Handler and slow failover with large
	number of LUNS
Date: Mon, 06 Apr 2009 10:47:06 -0700
Message-ID: <1239040026.25764.4.camel@chandra-ubuntu>
References: <1238880636.11478.8.camel@chandra-ubuntu>
	<8F08A56613D77044BD153E2AC5DA0F8401A817E4@CORPUSMX40A.corp.emc.com>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8F08A56613D77044BD153E2AC5DA0F8401A817E4@CORPUSMX40A.corp.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: berthiaume_wayne@emc.com
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, Babu.Moger@lsi.com
List-Id: linux-scsi@vger.kernel.org


On Mon, 2009-04-06 at 11:38 -0400, berthiaume_wayne@emc.com wrote:
> Hi Chandra.
> 
> 	We're currently testing 1024 LUNs across four paths with the
> older handler but will be doing the same with the new handler later this

Hi Wayne,

What do you mean by "older" handler ? dm_emc ?

> month. It sounds like I should move this up in the queue. 
> 
> Regards,
> Wayne. 
> 
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Chandra
> Seetharaman
> Sent: Saturday, April 04, 2009 5:31 PM
> To: dm-devel; Linux SCSI Mailing list
> Cc: Moger, Babu
> Subject: SCSI Hardware Handler and slow failover with large number of
> LUNS
> 
> Hello All,
> 
> During testing with the latest SCSI DH Handler on a rdac storage, Babu
> found that the failover time with 100+ luns takes about 15 minutes,
> which is not good.
> 
> We found that the problem is due to the fact that we serialize activate
> in dm on the work queue.
> 
> We can solve the problem in rdac handler in 2 ways
>  1. batch up the activates (mode_selects) and send few of them.
>  2. Do mode selects in async mode.
> 
> Just wondering if anybody had seen the same problem in other storages
> (EMC, HP and Alua). 
> 
> Please share your experiences, so we can come up with a solution that
> works for all hardware handlers.
> 
> regards,
> 
> chandra
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
