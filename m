From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: RE: Re: [PATCH 7/7] scsi_dh: attach to hardware handler
	fromdm-mpath
Date: Mon, 19 May 2008 13:01:43 -0700
Message-ID: <1211227303.21974.384.camel@chandra-ubuntu>
References: <20080514144338.714F910B5DF@craiglockhart-ipmi.suse.de>
	<1210819801.21974.266.camel@chandra-ubuntu><482C0676.9070004@suse.de>
	<1210964001.21974.351.camel@chandra-ubuntu> <483154B0.7020500@suse.de>
	<46A00B48CC54E4468EF6911F877AC4CA01618D5D@blrx3m10.blr.amer.dell.com>
Reply-To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46A00B48CC54E4468EF6911F877AC4CA01618D5D@blrx3m10.blr.amer.dell.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Shyam_Iyer@Dell.com
Cc: James.Bottomley@HansenPartnership.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Shyam,

Yes, the usefulness is understood. Hannes made that available thru the
dh_state parameter (2/7 of this series). 

Just an FYI.

chandra
On Tue, 2008-05-20 at 00:41 +0530, Shyam_Iyer@Dell.com wrote:
> >Chandra Seetharaman wrote:
> >> Hence, there is no need to attach it again from the multipath layer.
> 
>  Hannes Reinecke wrote:
> >Yes, you do. The user might have it's own custom configuration file,
> covering new/unknown/unhandled/testing devices, which out of necessity
> are _not_
> >hardcoded in the device table of the device handler.
> >So multipath has to have a way of attaching device handler to those
> devices, too. 
> 
> Quite agree. There are a lot of OEM vendors that may use for example the
> LSI RDAC conrtoller but the SCSI inquiry for these devices return the
> OEM device names. 
> The DELL MD3000 is an example of such a box. Instead of hardcoding
> device tables of the handler if they could be configured using a custom
> configuration file enabling new hardware becomes such a bliss.
> 
> -Shyam Iyer
> 
