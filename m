From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH 0/11]: Update megaraid_sas driver explanation
Date: Tue, 21 Dec 2010 12:49:48 -0800
Message-ID: <AANLkTimt9vcdZMTzyn-jxQ=Sk_yw5Bm9STsVVembfu2a@mail.gmail.com>
References: <AANLkTi=xOBgxZ8eJuYbKUAjHQ-uC1rr-qdU8UT-vMt9H@mail.gmail.com>
	<20101221202620.GA15750@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46792 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab0LUUtt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Dec 2010 15:49:49 -0500
Received: by qyj19 with SMTP id 19so5700801qyj.19
        for <linux-scsi@vger.kernel.org>; Tue, 21 Dec 2010 12:49:49 -0800 (PST)
In-Reply-To: <20101221202620.GA15750@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "bo.yang" <bo.yang@lsi.com>

On Tue, Dec 21, 2010 at 12:26 PM, Christoph Hellwig <hch@infradead.org>=
 wrote:
> So what's the actual shared code with older megaraid_sas adapters aft=
er
> this? =A0It looks to me like you should simply add another driver for=
 the
> new hardware.
>

Christoph,

The shared code with older megaraid_sas driver is all of the following
functions:

megasas_get_cmd()
megasas_return_cmd()
megasas_issue_polled()
megasas_issue_blocked_cmd()
megasas_issue_blocked_abort_cmd()
megasas_is_ldio()
megasas_queue_command()
megasas_lookup_instance()
megasas_slave_configure()
megaraid_sas_kill_hba()
megasas_check_and_restore_queue_depth()
megasas_reset_timer()
megasas_reset_bus_host()
megasas_bios_param()
megasas_service_aen()
megasas_slave_alloc()
megasas_complete_int_cmd()
megasas_complete_abort()
megasas_complete_cmd()
megasas_transition_to_ready()
megasas_teardown_frame_pool()
megasas_create_frame_pool()
megasas_free_cmds()
megasas_alloc_cmds()
megasas_get_pd_list()
megasas_get_ld_list()
megasas_get_ctrl_info()
megasas_get_seq_num()
megasas_register_aen()
megasas_start_aen()
megasas_io_attach()
megasas_set_dma_mask()
megasas_shutdown_controller()
=2E.. several more

The new adapter needs about 4k of code that is in the existing driver.
 That is why we made this a combined driver.

-Adam
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
