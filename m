From: "Zhao Forrest" <forrest.zhao@gmail.com>
Subject: What's the relation between libsas and scsi_transport_sas.c?
Date: Fri, 9 Nov 2007 17:26:53 +0800
Message-ID: <ac8af0be0711090126o4fc06572scd8e353cd1e1b694@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.235]:54138 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbXKIJ0y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Nov 2007 04:26:54 -0500
Received: by nz-out-0506.google.com with SMTP id s18so453887nze
        for <linux-scsi@vger.kernel.org>; Fri, 09 Nov 2007 01:26:54 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I found that libsas also reference to code of scsi_transport_sas.c.
Will scsi_transport_sas.c be removed finally?
If we add a new SAS LLDD to linux kernel, we should use libsas instead
of the functions defined in scsi_transport_sas.c, right?

Thanks,
Forrest
