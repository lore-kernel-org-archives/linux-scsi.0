From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: blacklist microtek scanmaker III
Date: Wed, 23 Feb 2005 13:53:30 -0800
Message-ID: <OF8815A4FA.C80FF4C5-ON88256FB1.007782C6-88256FB1.0078355F@us.ibm.com>
References: <20050223193138.GI32098@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Received: from e3.ny.us.ibm.com ([32.97.182.143]:35805 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261619AbVBWVxi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2005 16:53:38 -0500
In-Reply-To: <20050223193138.GI32098@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

I notice that Scanmaker II is already in the list, apparently in the wrong 
place.  Maybe you could fix that in the same patch, so the entries are 
conveniently together.

Also: the only reason this caught my eye is that just a few days ago, I 
discovered my Scanmaker I has the same problem (responds to all LUNs) and 
investigated briefly.  I guess I should get the vendor/model for it and 
throw that in too.

