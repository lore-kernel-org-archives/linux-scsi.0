From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH] isci: Make warning messages unique
Date: Tue, 13 Sep 2011 12:38:09 -0700
Message-ID: <CABE8wwvkCG7coTpXWOYAo7xymRnKHQgr=TNVEUCgaC_YnjTpSw@mail.gmail.com>
References: <4E6E6F94.4050502@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:52122 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932166Ab1IMTiN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Sep 2011 15:38:13 -0400
In-Reply-To: <4E6E6F94.4050502@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tim Gardner <tim.gardner@canonical.com>
Cc: edmund.nadolski@intel.com, dave.jiang@intel.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Sep 12, 2011 at 1:46 PM, Tim Gardner <tim.gardner@canonical.com> wrote:
> Hi,
>
> I've got a 2-way Sandybridge server with an 'Intel(R) C600 SAS Controller'.
> The driver makes a boatload of dmesg noise with non-unique messages
> distinguished only by the event code. For example, I've got 296 of these in
> dmesg:
>
> (NULL device *): sci_phy_event_handler:735: PHY starting substate machine
> received unexpected event_code b3402000
>
> In an effort to discover which of the 9 places from which this message was
> emitted I added a line number.
>
> The next step is to decide if all of these really need to be dev_warn().

Can you describe your storage layout?  I'd like to move these to
dev_dbg() but I want to verify that the reports are benign.
