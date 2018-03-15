From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH] bfa: remove VLA
Date: Thu, 15 Mar 2018 11:40:05 +0000
Message-ID: <32130f556f09408686626c50c70b39c9@AcuMS.aculab.com>
References: <20180308213841.13807-1-steve@sk2.org>
 <yq18tau7y4f.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq18tau7y4f.fsf@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "'Martin K. Petersen'" <martin.petersen@oracle.com>, Stephen Kitt <steve@sk2.org>
Cc: "hare@suse.com" <hare@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> > -		sizeof(wwn_t[iocmd->nports])) != BFA_STATUS_OK) {
> > +		sizeof(wwn_t) * iocmd->nports) != BFA_STATUS_OK) {
> 
> These parentheses made me blurry eyed but it's actually OK.

		iocmd->nports * sizeof(wwn_t)) != BFA_STATUS_OK) {

is easier to focus on :-)

	David
