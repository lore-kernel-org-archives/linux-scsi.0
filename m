From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: Re: [PATCH 0/2] dm: Add no_abort_q feature flag to
	dm-mpath
Date: Wed, 5 May 2010 17:19:57 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF498E060CB@cosmail01.lsi.com>
References: <1272945691-31649-1-git-send-email-andmike@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1272945691-31649-1-git-send-email-andmike@linux.vnet.ibm.com>
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
To: Mike Anderson <andmike@linux.vnet.ibm.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Mike Anderson
> Sent: Monday, May 03, 2010 11:01 PM
> To: dm-devel@redhat.com
> Cc: linux-scsi@vger.kernel.org
> Subject: [PATCH 0/2] dm: Add no_abort_q feature flag to dm-mpath
> 
> This patch series contains two patches.
> 
> 1.) The first patch adds a feature flags bit field to the multipath
> structure for selected features.
> 
> 2.) The second patch allows a user to set a feature flag for a dm-mpath
> device of "no_abort_q" to indicate that deactivate_path should not call
> blk_abort_queue. I tried to select a short feature name to feature
> output
> listed with multipath -l would not be too long "features='2
> queue_if_no_path
> no_abort_q'

Mike, 
 In what special circumstances you recommend to use this feature? It would be great if you could add that explanation in your patch descriptions. 
