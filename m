Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A006AC433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 07:00:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8304C221ED
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 07:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgGNHAt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 03:00:49 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:46769 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbgGNHAs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 03:00:48 -0400
Received: from delius.hannes-reinecke.de ([62.216.205.241]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis)
 id 1MZCSt-1kPiFo3eSX-00VAPE; Tue, 14 Jul 2020 09:00:30 +0200
Subject: Re: [PATCH v2 05/29] scsi: fcoe: fcoe_ctlr: Fix a myriad of
 documentation issues
To:     Lee Jones <lee.jones@linaro.org>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20200713074645.126138-1-lee.jones@linaro.org>
 <20200713074645.126138-6-lee.jones@linaro.org>
From:   Hannes Reinecke <mail@hannes-reinecke.de>
Message-ID: <975ab8d4-eedc-c763-c2c6-436344395fb8@hannes-reinecke.de>
Date:   Tue, 14 Jul 2020 09:00:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200713074645.126138-6-lee.jones@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:ujIthiS4hQqAiJrnRyjNtwwK7tV4zSCotIdL00jCCZRzFqhRN0W
 35AkBzP14epreMh3knDetK9JXuUneA6mHlzMwdghtXW86gEnQU0h0leTdLwJGUMRCJXxBKU
 ZhHMpN37DVAeO8Dkg6kactdieyDVjKMWxn1v+JKdfMwdrfBTUprQJn9UqqGhY55fw169z0c
 fQq8xuWXH7GkMI1yC74GQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:R4lhW7mb9sg=:/3mZLCTcb0l3mzr53A107C
 HH845y/kK8ApVCt3P4O/A8Wd5Lv0kPEhwTvBdoXvKJo1okCoV8I3EEFTrkQDzmT/Oa3BwgbzP
 YjO/b2iyauwuD+NwR31ULbkEvKfKf2GggGJn8Pn85Sz0YZNcncOFPX+XB75+vQIdi3cbhLoN8
 G5SPy2Y/Eahq2xAEopeeaPyCGYbDP2hTNZqoAET/4A3zjtXsMX3vjX9kb/HAtbe1/hZsdozJM
 IJwvQXmvI+bJlirGdnWMGH7EX7JdCQohGF9hFd2gQofM+BxBmncd55kC+Q7wsTUaCLLibTmz5
 lkP6af/i/mpVmNWUyaAluiaxErw+ZKkrHJ63ANFKmlLX/nAOPyw64iBhx9R3X1mcJB3DF+wzV
 n2WlJfwulkpdB84lN0b3jkEeSZ1KDvc5c/5O9IjaVtxcxmr0nM6yjnkLGxBYf5jOxnCTkEm81
 2WPs6E0DeM5ceXA5M+/Z25u/O6bb+f5OfnqSwhJ1AS5vnzhZopOai+6Qqn2uK1nVnEblqa8iO
 e9CKJmbcRfmGxyjxjwsFGDls/16kEqJEaAxeEXKMuFYIWZmA4V6Dzh8AZ3OfTbvcw9VfBfici
 eDFTK412yo5Hq4cDjldOI26wpmynfjzC4KQpAVnW3U4ZtPgdsAoA8wTe3MuiYkttXTh2W7svW
 vIHTQfKUeHhZwen5wl/blFK6AGJv9DWlYzmXYqC5mNqWd7NQQGLyQLuoMUL5ExjSZL8sJCvZZ
 aOejRtmfFhswh9+OzH09qBe3Yc80ul4EGtpX8zsHSDjSs5rv0LHMcYVgBLH6V58u18Val3jHB
 PMr0yYBgBMF/+Wz6T1p13+2hPDz3x0AOUfqYZ6ZGmldZnl4c1ev3jz4XrHN2IZ2UX/VJDDM
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/20 9:46 AM, Lee Jones wrote:
> Mostly missing or incorrect (bitrotted) function parameters.
> 
> Fixes the following W=1 kernel build warning(s):
> 
>   drivers/scsi/fcoe/fcoe_ctlr.c:139: warning: Function parameter or member 'mode' not described in 'fcoe_ctlr_init'
>   drivers/scsi/fcoe/fcoe_ctlr.c:604: warning: Function parameter or member 'lport' not described in 'fcoe_ctlr_encaps'
>   drivers/scsi/fcoe/fcoe_ctlr.c:1312: warning: Function parameter or member 'skb' not described in 'fcoe_ctlr_recv_clr_vlink'
>   drivers/scsi/fcoe/fcoe_ctlr.c:1312: warning: Excess function parameter 'fh' description in 'fcoe_ctlr_recv_clr_vlink'
>   drivers/scsi/fcoe/fcoe_ctlr.c:1781: warning: Function parameter or member 't' not described in 'fcoe_ctlr_timeout'
>   drivers/scsi/fcoe/fcoe_ctlr.c:1781: warning: Excess function parameter 'arg' description in 'fcoe_ctlr_timeout'
>   drivers/scsi/fcoe/fcoe_ctlr.c:1904: warning: Function parameter or member 'lport' not described in 'fcoe_ctlr_recv_flogi'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2166: warning: Function parameter or member 'lport' not described in 'fcoe_ctlr_disc_stop_locked'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2166: warning: Excess function parameter 'fip' description in 'fcoe_ctlr_disc_stop_locked'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2188: warning: Function parameter or member 'lport' not described in 'fcoe_ctlr_disc_stop'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2188: warning: Excess function parameter 'fip' description in 'fcoe_ctlr_disc_stop'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2204: warning: Function parameter or member 'lport' not described in 'fcoe_ctlr_disc_stop_final'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2204: warning: Excess function parameter 'fip' description in 'fcoe_ctlr_disc_stop_final'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2273: warning: Function parameter or member 'frport' not described in 'fcoe_ctlr_vn_parse'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2273: warning: Excess function parameter 'rdata' description in 'fcoe_ctlr_vn_parse'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2804: warning: Function parameter or member 'frport' not described in 'fcoe_ctlr_vlan_parse'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2804: warning: Excess function parameter 'rdata' description in 'fcoe_ctlr_vlan_parse'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2900: warning: Excess function parameter 'min_len' description in 'fcoe_ctlr_vlan_send'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2977: warning: Function parameter or member 'fip' not described in 'fcoe_ctlr_vlan_recv'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2977: warning: Function parameter or member 'skb' not described in 'fcoe_ctlr_vlan_recv'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2977: warning: Excess function parameter 'lport' description in 'fcoe_ctlr_vlan_recv'
>   drivers/scsi/fcoe/fcoe_ctlr.c:2977: warning: Excess function parameter 'fp' description in 'fcoe_ctlr_vlan_recv'
>   drivers/scsi/fcoe/fcoe_ctlr.c:3033: warning: Function parameter or member 'callback' not described in 'fcoe_ctlr_disc_start'
>   drivers/scsi/fcoe/fcoe_ctlr.c:3033: warning: Function parameter or member 'lport' not described in 'fcoe_ctlr_disc_start'
>   drivers/scsi/fcoe/fcoe_ctlr.c:3033: warning: Excess function parameter 'fip' description in 'fcoe_ctlr_disc_start'
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   drivers/scsi/fcoe/fcoe_ctlr.c | 26 +++++++++++++-------------
>   1 file changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
> index 1791a393795da..99242f9856708 100644
> --- a/drivers/scsi/fcoe/fcoe_ctlr.c
> +++ b/drivers/scsi/fcoe/fcoe_ctlr.c
> @@ -134,6 +134,7 @@ static void fcoe_ctlr_map_dest(struct fcoe_ctlr *fip)
>   /**
>    * fcoe_ctlr_init() - Initialize the FCoE Controller instance
>    * @fip: The FCoE controller to initialize
> + * @mode: FIP mode to set
>    */
>   void fcoe_ctlr_init(struct fcoe_ctlr *fip, enum fip_mode mode)
>   {
> @@ -587,6 +588,7 @@ static void fcoe_ctlr_send_keep_alive(struct fcoe_ctlr *fip,
>   /**
>    * fcoe_ctlr_encaps() - Encapsulate an ELS frame for FIP, without sending it
>    * @fip:   The FCoE controller for the ELS frame
> + * @lport: The local port
>    * @dtype: The FIP descriptor type for the frame
>    * @skb:   The FCoE ELS frame including FC header but no FCoE headers
>    * @d_id:  The destination port ID.
> @@ -1302,7 +1304,7 @@ static void fcoe_ctlr_recv_els(struct fcoe_ctlr *fip, struct sk_buff *skb)
>   /**
>    * fcoe_ctlr_recv_els() - Handle an incoming link reset frame
>    * @fip: The FCoE controller that received the frame
> - * @fh:	 The received FIP header
> + * @skb: The received FIP packet
>    *
>    * There may be multiple VN_Port descriptors.
>    * The overall length has already been checked.
> @@ -1775,7 +1777,7 @@ static void fcoe_ctlr_flogi_send(struct fcoe_ctlr *fip)
>   
>   /**
>    * fcoe_ctlr_timeout() - FIP timeout handler
> - * @arg: The FCoE controller that timed out
> + * @t: Timer context use to obtain the controller reference
>    */
>   static void fcoe_ctlr_timeout(struct timer_list *t)
>   {
> @@ -1887,6 +1889,7 @@ static void fcoe_ctlr_recv_work(struct work_struct *recv_work)
>   /**
>    * fcoe_ctlr_recv_flogi() - Snoop pre-FIP receipt of FLOGI response
>    * @fip: The FCoE controller
> + * @lport: The local port
>    * @fp:	 The FC frame to snoop
>    *
>    * Snoop potential response to FLOGI or even incoming FLOGI.
> @@ -2158,7 +2161,7 @@ static struct fc_rport_operations fcoe_ctlr_vn_rport_ops = {
>   
>   /**
>    * fcoe_ctlr_disc_stop_locked() - stop discovery in VN2VN mode
> - * @fip: The FCoE controller
> + * @lport: The local port
>    *
>    * Called with ctlr_mutex held.
>    */
> @@ -2179,7 +2182,7 @@ static void fcoe_ctlr_disc_stop_locked(struct fc_lport *lport)
>   
>   /**
>    * fcoe_ctlr_disc_stop() - stop discovery in VN2VN mode
> - * @fip: The FCoE controller
> + * @lport: The local port
>    *
>    * Called through the local port template for discovery.
>    * Called without the ctlr_mutex held.
> @@ -2195,7 +2198,7 @@ static void fcoe_ctlr_disc_stop(struct fc_lport *lport)
>   
>   /**
>    * fcoe_ctlr_disc_stop_final() - stop discovery for shutdown in VN2VN mode
> - * @fip: The FCoE controller
> + * @lport: The local port
>    *
>    * Called through the local port template for discovery.
>    * Called without the ctlr_mutex held.
> @@ -2262,7 +2265,7 @@ static void fcoe_ctlr_vn_start(struct fcoe_ctlr *fip)
>    * fcoe_ctlr_vn_parse - parse probe request or response
>    * @fip: The FCoE controller
>    * @skb: incoming packet
> - * @rdata: buffer for resulting parsed VN entry plus fcoe_rport
> + * @frport: parsed FCoE rport from the probe request
>    *
>    * Returns non-zero error number on error.
>    * Does not consume the packet.
> @@ -2793,7 +2796,7 @@ static int fcoe_ctlr_vn_recv(struct fcoe_ctlr *fip, struct sk_buff *skb)
>    * fcoe_ctlr_vlan_parse - parse vlan discovery request or response
>    * @fip: The FCoE controller
>    * @skb: incoming packet
> - * @rdata: buffer for resulting parsed VLAN entry plus fcoe_rport
> + * @frport: parsed FCoE rport from the probe request
>    *
>    * Returns non-zero error number on error.
>    * Does not consume the packet.
> @@ -2892,7 +2895,6 @@ static int fcoe_ctlr_vlan_parse(struct fcoe_ctlr *fip,
>    * @fip: The FCoE controller
>    * @sub: sub-opcode for vlan notification or vn2vn vlan notification
>    * @dest: The destination Ethernet MAC address
> - * @min_len: minimum size of the Ethernet payload to be sent
>    */
>   static void fcoe_ctlr_vlan_send(struct fcoe_ctlr *fip,
>   			      enum fip_vlan_subcode sub,
> @@ -2969,9 +2971,8 @@ static void fcoe_ctlr_vlan_disc_reply(struct fcoe_ctlr *fip,
>   
>   /**
>    * fcoe_ctlr_vlan_recv - vlan request receive handler for VN2VN mode.
> - * @lport: The local port
> - * @fp: The received frame
> - *
> + * @fip: The FCoE controller
> + * @skb: The received FIP packet
>    */
>   static int fcoe_ctlr_vlan_recv(struct fcoe_ctlr *fip, struct sk_buff *skb)
>   {
> @@ -3015,9 +3016,8 @@ static void fcoe_ctlr_disc_recv(struct fc_lport *lport, struct fc_frame *fp)
>   	fc_frame_free(fp);
>   }
>   
> -/**
> +/*
>    * fcoe_ctlr_disc_recv - start discovery for VN2VN mode.
> - * @fip: The FCoE controller
>    *
>    * This sets a flag indicating that remote ports should be created
>    * and started for the peers we discover.  We use the disc_callback
> 
Please, this should continue to be a kernel-doc comment; my copy still 
has this header:

/**
  * fcoe_ctlr_disc_recv - discovery receive handler for VN2VN mode.
  * @lport: The local port
  * @fp: The received frame
  *

What happened to it?

Cheers,

Hannes
