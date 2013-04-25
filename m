From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH 2/2] dm mpath: attach scsi_dh during table resume
Date: Thu, 25 Apr 2013 16:44:13 +0100
Message-ID: <51794F4D.1020206@redhat.com>
References: <20130404131631.GA10208@redhat.com> <1365457816-31475-1-git-send-email-snitzer@redhat.com> <1365457816-31475-2-git-send-email-snitzer@redhat.com> <20130422223355.GA4803@redhat.com> <Pine.LNX.4.64.1304250938480.8307@file.rdu.redhat.com> <20130425141707.GA1947@redhat.com> <Pine.LNX.4.64.1304251037320.18633@file.rdu.redhat.com> <51794B67.2000903@redhat.com> <20130425153757.GB2488@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757820Ab3DYPoi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Apr 2013 11:44:38 -0400
In-Reply-To: <20130425153757.GB2488@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org, hare@suse.de

On 04/25/2013 04:37 PM, Mike Snitzer wrote:> clariion_match does more 
than check the vendor and product; if tpgs is
 > set (ALUA mode) it returns false.
 >
 > So yes, while there is room for improvement in clariion_match the
 > current code should work just fine with reasoning between emc and alua.

Duh, sorry you're right. Completely missed the test for tpgs in emc.


