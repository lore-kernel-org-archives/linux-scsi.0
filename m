From: Mark Hounschell <markh-n2QNKt385d+sTnJN9+BGXg@public.gmane.org>
Subject: Re: BUG: SCSI aic7xxx driver and AMD IOMMU
Date: Tue, 24 Mar 2015 07:57:49 -0400
Message-ID: <5511513D.6090106@compro.net>
References: <54E1FFFA.1060403@compro.net> <54F60D33.8090401@compro.net>
	<20150323150304.GQ4441@8bytes.org>
Reply-To: markh-n2QNKt385d+sTnJN9+BGXg@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20150323150304.GQ4441-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
Cc: iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org >> SCSI development list" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 03/23/2015 11:03 AM, Joerg Roedel wrote:
> Hi Mark,
>
> On Tue, Mar 03, 2015 at 02:36:19PM -0500, Mark Hounschell wrote:
>> It looks like this problem is NOT a bug with the SCSI aic7xxx driver
>> after all. I can duplicate this BUG very easily with other hardware.
>> Simply removing a driver module  (whether it its self, has actually
>> used any of the DMA API or not) that is sitting on the same pci bus
>> as a card that is actually using DMA will cause this. And that card
>> that is in use and using DMA will no longer function. It "looks and
>> feels" like unloading a module causes the IOMMU to improperly unmap
>> valid mappings.
>
> You are right, I looked into the code and found the problem. I'll post a
> fix for testing this week.
>

I'll be happy to test it.

Regards
Mark
