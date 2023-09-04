Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04AA0C83F2C
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Sep 2023 10:55:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352735AbjIDKz6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Sep 2023 06:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351821AbjIDKz5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Sep 2023 06:55:57 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62102191;
        Mon,  4 Sep 2023 03:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693824950; x=1725360950;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sqs2mJi4XhUaL58AyKzjuKO8eS4mzUoGVNQWwx6UuGw=;
  b=QzuTP70qui4I/vOzj2vZSSCkV337eQQR9glz74VJcUcOBxnNl1m953no
   HRJUrd5zFizdKWFXCFyPDGqEQ19dTSlgXtKP6uPEJC1vfHngjeKa+HmvN
   V23ScifTzD4FSez+kB2dnwPNROPJYUzg2NQCmv318vZrK+ShecEp7QXTV
   NemgZaFCf2ZvRqPJlcclpQZHQqbTGUl4ab2FlSG6GPpAc4L4PHQSHh0BZ
   l8A4VYgiDMlkAY7kYNeJah85Fl27OPgXo9ylN5mpdI96KC5XHSMqtlfrr
   prZubuWxMDwlY4SSGh/e4t+ClHHnU54L3+xID9kOOCykhMJ18bCqPXVo5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="442973764"
X-IronPort-AV: E=Sophos;i="6.02,226,1688454000"; 
   d="scan'208";a="442973764"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2023 03:55:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="769952856"
X-IronPort-AV: E=Sophos;i="6.02,226,1688454000"; 
   d="scan'208";a="769952856"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2023 03:55:44 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1qd7Es-006P9i-2Q;
        Mon, 04 Sep 2023 13:55:26 +0300
Date:   Mon, 4 Sep 2023 13:55:26 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Xingui Yang <yangxingui@huawei.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        john.g.garry@oracle.com, damien.lemoal@opensource.wdc.com,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        himanshu.madhani@cavium.com, felipe.balbi@linux.intel.com,
        gregkh@linuxfoundation.org, uma.shankar@intel.com,
        anshuman.gupta@intel.com, animesh.manna@intel.com,
        linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        prime.zeng@hisilicon.com, kangfenglong@huawei.com,
        chenxiang66@hisilicon.com
Subject: Re: [PATCH v5 2/3] scsi: hisi_sas: Use DEFINE_SHOW_STORE_ATTRIBUTE
 helper for debugfs
Message-ID: <ZPW3nqllvv7JjYmi@smile.fi.intel.com>
References: <20230904084804.39564-1-yangxingui@huawei.com>
 <20230904084804.39564-3-yangxingui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230904084804.39564-3-yangxingui@huawei.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 04, 2023 at 08:48:03AM +0000, Xingui Yang wrote:
> Use DEFINE_SHOW_STORE_ATTRIBUTE helper for read-write file to reduce some

DEFINE_SHOW_STORE_ATTRIBUTE()

> duplicated code.
> 
> Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
> Signed-off-by: Xingui Yang <yangxingui@huawei.com>

Same comments about tags as in previous patch.

Code wise LGTM, FWIW,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>


-- 
With Best Regards,
Andy Shevchenko


